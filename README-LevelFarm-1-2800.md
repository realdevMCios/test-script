# Trapreal Hub — Level Farm 1–2800

This branch adds a unified level progression to the existing WindUI-based script from the supplied `message(1).txt`.

## What changed

- Uses the existing **Farm Level** mode and adds a **Auto Sea Progression (Sea 1 → Sea 3)** toggle on the Main tab.
- At level 700 in Sea 1, starts the existing Detective / Key / Ice Admiral Sea 2 unlock flow.
- After the game reports Sea 2, releases the Sea 2 task and resumes level farming.
- At level 1500 in Sea 2, starts the existing Bartilo / Trevor / Don Swan / Rip Indra Sea 3 unlock flow.
- After the game reports Sea 3, releases the unlock task and resumes level farming.
- Restricts the level-2600 Submerged Island travel to Sea 3 and retries unless arrival is verified.
- Stops the level mode when level 2800 is reached in Sea 3.
- Allows quests with a one-kill requirement to be selected.

## Install

After this pull request is merged, run the contents of `trap-real-kaitun-2800.txt`, or execute the Lua file directly.

**Public-repository safety:** hard-coded Discord webhook URLs from the supplied source were blanked before publishing. Configure your own webhook in the UI/configuration if you use those optional features. Existing external script dependencies were otherwise retained.

## Validation

Static source checks were performed. This script was not executed in Roblox, so Sea unlocks, teleport remotes, and the level loop still need an in-game test.
