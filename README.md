# Ace Combat 6: Fires of Liberation - Post-processing modifier table

A cheat table that will let you toggle some post-processing effects used in gameplay, as well as display their current configuration values.

I was interested to see if it was possible to modify these effects to either reduce them or remove them altogether. Doing some research by poking at Xenia's memory while the game was running, I discovered that the game reads the configuration of these post-processing parameters from XML files.

Unfortunately, the game's assets are compressed and encrypted so patching these files directly is not feasible (at least for me). Xenia Canary has support for game patches that are applied during runtime, so I gave it a shot to debug the executable, find the code that handles the post-processing and create a patch. However it turned out to be far too difficult for me so I decided to use Cheat Engine (CE) to achieve these goals as well make these values accessible to anyone interested in researching them.

Besides modifying post-processing effects, I also included a script that will remove the clouds and the distance fog of the current stage, for if you ever wanted to get a better look at it.

#### Download links:

- Check the [releases]() section.

#### Required files and tools:

- Cheat Engine 7.5 or latest installed in your computer. You can download the program from its [official website](https://www.cheatengine.org/).

- Xenia Canary emulator ([official website](https://github.com/xenia-canary/xenia-canary-releases)).

- A compatible ISO file of Ace Combat 6: Fires of Liberation **[See NOTES]**.

#### Usage:

Load the game in Xenia Canary and click on the **Click here to start** script. From there, click on the script for the effect you want to disable, or choose the option to view the post-processing values used in the current mission.

Once activated, the scripts will apply the modifications while you are in a mission, or remain on standby until you enter a mission. They will also automatically disable if you close the emulator.

The **Print post-processing parameters** script will automatically create entries for the currently loaded post-processing values if activated during a mission. If you are not in a mission, it will delete existing entries and wait until you enter one again.

----

#### Examples:

- Original image output:

![ac6pp_04](https://github.com/user-attachments/assets/82490310-45b7-463f-b6b9-b5fd17e24503)

- Vignetting disabled:

![ac6pp_05](https://github.com/user-attachments/assets/b9a0318b-6f85-432b-9996-e7562b3f2eb8)

- HDR (+ vignetting) disabled:

![ac6pp_06](https://github.com/user-attachments/assets/32b1161a-5bbc-4e7d-b5bf-cce6e9915fa1)

- Level correction (+ HDR + vignetting) disabled:

![ac6pp_07](https://github.com/user-attachments/assets/7d3b6ddd-c3be-4e76-8b01-3373ad24f888)

- Draw distance and fog removed (+ level correction + HDR + vignetting) disabled:

![ac6pp_08](https://github.com/user-attachments/assets/c0a119ff-5faf-4747-af0a-db35fd438839)

- List of parameters created by the **Print post-processing parameters** script:

<img width="580" height="502" alt="ac6pp_03" src="https://github.com/user-attachments/assets/b179c742-a9db-45d7-9049-d0f057d802a9" />

----

#### Other post-processing effects and cutscenes:

Some post-processing effects used in cutscenes (such as chromatic aberration, depth of field, custom vignetting, and other effects I may have missed) are not supported by this table.

There are two types of cutscenes that play depending on the situation:

- Campaign/Scene Viewer Cutscenes: These play between missions or can be accessed via the SCENE VIEWER. The table will not work with these.

- In-Engine/Mission Cutscenes: These play within a mission (e.g., the opening sequence or the Aigaion’s entrance in Mission 1). The table works partially with these.

While the table is incompatible with the first type, it functions partially during mission-integrated sequences.

![ac6pp_01](https://github.com/user-attachments/assets/f8b6cf4e-774e-41be-aed6-f1449b3714de)

![ac6pp_02](https://github.com/user-attachments/assets/109b38ae-f5d7-470e-af45-98f3144ffffc)

----

#### Notes:

- This table is only compatible with the NTSC-U release of the game with its title updates applied. To check if you have the right version (and to ensure it is updated), the Xenia menu bar should display the following string:

	>[4E4D07D1 v0.0.2.8] ACE COMBAT 6

- **Cheat Engine will not display big-endian floating-point numbers by default!** If you enable the **Print post-processing parameters** script without configuring CE to show this data type first, the entries will display nothing under the **VALUE** column.

	To enable custom data types in CE, go to the menu bar and click **Edit > Settings > Extra Custom Types**, then check the **"2/4 Byte/Float Big Endian"** boxes. Click OK to save and close the settings.

- There might be a few seconds of delay before any of the scripts apply their modifications, especially if a mission is restarted. The post-processing parameters are reverted to their default values every time a mission restarts or updates, so the script checks every five seconds to see if a restart/update has occurred and then reapplies the changes.

- When changing the values of the parameters printed by the **Print post-processing parameters** script, keep in mind that you won't be able to restore them to their default values unless you disable their respective scripts.

	|**Variable name**|**Script to disable**|
	|-|-|
	|HDR*|Disable HDR|
	|Vignetting*|Disable vignette|
	|LevelCorrection*|Disable level correction|

- The **Remove fog and clouds** script increases the draw distance of the current stage. **This can potentially cause performance drops or game crashes due to the increased number of objects to render!**.

#### Special thanks:

- **BelkanLoyalist** ([X](https://x.com/BelkanLoyalist)/[ModDB](https://www.moddb.com/members/justauser1)) for testing.
