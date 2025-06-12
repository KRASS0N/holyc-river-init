import os
import shlex
from jinja2 import Environment, FileSystemLoader

commands_raw = []

with open("commands.txt", "r") as file:
    for line in file.read().splitlines():
        if line:
            commands_raw.append(shlex.split(line))

padding = None

max_length = max(len(command) for command in commands_raw) + 1

commands = [
    command + [padding] * (max_length - len(command))
    for command in commands_raw
]

environment = Environment(loader=FileSystemLoader("."))
template = environment.get_template("init.template.HC")

holyc = template.render(
    command_num=len(commands),
    max_length=max_length,
    commands=commands
)

with open("init.HC", "w") as file:
    file.write(holyc)
