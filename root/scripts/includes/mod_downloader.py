#!/usr/bin/python3
# -*- coding: utf-8 -*-

from glob import glob

# System Imports
from os import getenv
from os import mkdir
from os import remove as delete_file
from pathlib import PurePath
from pprint import pprint
from re import search
from sys import exit as sys_exit
from urllib.parse import quote

# Local Imports
from python_logger import create_logger
from requests import get as http_get

MODS_FOLDER = "/mnt/ramdisk/mods/"
MODS_LIST = "/mnt/ramdisk/modlist.conf"


def file_download(url):
    path, url = url
    r = http_get(url, stream=True)

    mod_name = path[0 : search(r"\d", path).start() - 1]
    old_mod_files = glob(f"{MODS_FOLDER}{mod_name}*")
    for f in old_mod_files:
        try:
            delete_file(f)
        except OSError:
            pass

    with open(f"{MODS_FOLDER}{path}", "wb") as f:
        f.write(r.content)


def curseforge_parse(api_data, minecraft_version):
    if (
        minecraft_version in api_data["download"]["versions"]
        and "Fabric" in api_data["download"]["versions"]
    ):
        base_id = api_data["download"]["url"][
            api_data["download"]["url"].rfind("/") + 1 :
        ]
        url = (
            "https://media.forgecdn.net/files/"
            + str(int(base_id[0:4]))
            + "/"
            + str(int(base_id[4:7]))
            + "/"
            + quote(api_data["download"]["name"])
        )
        return (api_data["download"]["name"], url)

    for item in api_data["files"]:
        if minecraft_version in item["versions"] and "Fabric" in item["versions"]:
            base_id = item["url"][item["url"].rfind("/") + 1 :]
            url = (
                "https://media.forgecdn.net/files/"
                + str(int(base_id[0:4]))
                + "/"
                + str(int(base_id[4:7]))
                + "/"
                + quote(item["name"])
            )
            return (item["name"], url)
    return None


def github_parse(api_data, minecraft_version):
    for releases in api_data:
        for assets in releases["assets"]:
            link = assets.get("browser_download_url")
            if link is not None and link.endswith("jar") and minecraft_version in link:
                return (link[link.rfind("/") + 1 :], link)
    return None


def main():

    logger = create_logger(PurePath(__file__).stem)

    mod_list_path = getenv("MINECRAFT_MOD_LIST", f"{MODS_LIST}")
    if mod_list_path is None:
        logger.info("Mod List Not Found")
        sys_exit()

    with open(f"{mod_list_path}", "r") as f:
        mod_list = [line.strip() for line in f.readlines()]

    mod_list = list(filter(lambda x: x, mod_list))
    mod_list = list(filter(lambda x: not x.startswith("#"), mod_list))

    minecraft_version = getenv("MINECRAFT_VERSION", "1.17")
    secondary_version = None

    if minecraft_version.count(".") == 2:
        secondary_version = minecraft_version[: minecraft_version.rfind(".")]

    logger.info(f"Getting Mods for MineCraft Version {minecraft_version}")

    logger.info("Parsing Mod List")
    download_list = []
    for url in mod_list:
        api_data = http_get(url)

        if "github" in url:
            parse_function = github_parse
        elif "cfwidget" in url:
            parse_function = curseforge_parse
        else:
            continue

        download_link = parse_function(api_data.json(), minecraft_version)
        if download_link is None and secondary_version is not None:
            download_link = parse_function(api_data.json(), secondary_version)

        if download_link is not None:
            download_list.append(download_link)

    try:
        mkdir(MODS_FOLDER)
    except OSError:
        pass

    logger.info("Downloading Mods")
    for x in download_list:
        file_download(x)

    logger.info("Installed Mods")
    logger.info(glob(f"{MODS_FOLDER}*"))


if __name__ == "__main__":
    main()
