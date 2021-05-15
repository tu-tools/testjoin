let URL = "https://git.tu-berlin.de/lenard-mollenkopf/algodat-sose21-tests/-/archive/master/algodat-sose21-tests-master.tar"

import httpclient
import strformat
import strutils
import os

echo "== TestJoin 1.0 - ©2021, Adrian Siebing - The MIT License == "
echo "> Downloading Tests"

var temp_target = os.join_path(os.get_temp_dir(), "algodat_tests.tar")
var unpacked_dir = os.split_file(URL).name
var client = httpclient.new_http_client()
client.download_file(URL, temp_target)

echo fmt"> Extracting from {temp_target}"
var result = os.exec_shell_cmd(&"tar -xf \"{temp_target}\"")
if result != 0:
    echo "Error: unpacking failed"
    quit(1)
if not os.dir_exists(unpacked_dir):
    echo fmt"Error: no directory {unpacked_dir}"
    quit(2)

stdout.write("> Integrating files")
stdout.flush_file()

for path in os.walk_dirs("*"):
    if path.startswith("Blatt") and os.dir_exists(os.join_path(unpacked_dir, path)):
        stdout.write(".")
        stdout.flush_file()
        os.copy_dir_with_permissions(os.join_path(unpacked_dir, path), path)
        if os.dir_exists(os.join_path(unpacked_dir, "Tests 2017", path)):
            stdout.write(".")
            stdout.flush_file()
            os.copy_dir_with_permissions(os.join_path(unpacked_dir, "Tests 2017", path), path)

os.remove_dir(unpacked_dir)
stdout.write("\nDone.\n")
stdout.flush_file()
