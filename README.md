# Econ Game Project

## Setup
1. Download the portable Godot Engine from https://godotengine.org/download/3.x/windows/ on Standard Version
2. Download GitKraken and try getting the Pro Version (students get it for free)
3. Clone the repo through URL in Gitkraken and put it somewhere safe
4. Open Godot and click import to select project.godot
5. If you wish to run, press F5 or the Play button in top right.
6. For more information follow Godot Tutorials, see: https://docs.godotengine.org/en/stable/community/tutorials.html

## Some reminders
* Godot is a node-based system that has underlying layers
* We are working on a 2D top-down project with a sort of childish vibe (Celeste)
* When adding a scene and attempting to add game mechanics such as physics or dialogue, attach a script to the scene to ensure that it works
* Keep this project organized! The assets file will include things like images, audio, etc. The scene folder will have any of the scenes that are added. And the scripts folder is where all scripts in GDScript or other languages should be saved (.gd is like .py)

## Run in browser
1. Export the Project to HTML5 somewhere on your computer.
2. Run an administrative command prompt.
3. CD into the directory with the game folders.
4. Run "python -m http.server 8000"
5. Type localhost in browser and click the html file.
