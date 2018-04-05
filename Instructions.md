# Instructions for PBS

## Layout

* **Hexes 1 & 0 -** selected attack's damage (max 15)
* **Hexes 3 & 2 -** selected attack's accuracy (out of 15)
* **Hexes 5 & 4 -** Your Pokemon's HP (max 15)
* **Hexes 7 & 6 -** Wild Pokemon's HP (max 15)
* **LEDRs 0-6 -** the current state in the battle (refer to the below section for an explanation of each state)
* **LEDR 16 -** indicates a failed catch attempt
* **LEDG 7 -** indicates catch successful (win)
* **LEDG 8 -** indicates wild Pokemon fainted (win)
* **LEDR 17** - indicates that your Pokemon has fainted (game over)
* **SW 1 & 0** - used to select your action (refer to State 1 below)
* **SW 3 & 2** - used to select your Pokemon's attack (refer to state 2 below)
* **KEY 0** - used to step through states

## States

This game operates in 6 states, which you traverse by clicking KEY0.
The states are as follows:

1. **Menu** - use switches 1 and 0 to select what action you will take. The available actions are:
     * **00 - Fight:** Moves you to the Move Selection state where you can choose an attack for your Pokemon
     * **11 - Heal:** Moves you to the Heal state
     * **01 - Catch:** Moves you the Catch state
2. **Attack Selection** - uses switches 3 and 2 to select which attack will be performed by your Pokemon. There are 4 available attacks. Attack data is displayed on Hexes 3 to 0 (refer to Layout above for more details). Afterwards, move onto state 3.
3. **Apply damage to wild Pokemon** - Takes the attack you chose in state 2, calculates a random value from 0-15, and compares it to the accuracy value of your attack. If the random value is *less* than your attack's accuracy, then that attack's damage value is subtracted from the wild Pokemon's HP. Afterwards, if the wild Pokemon's HP becomes 0, move onto the **victory** state. Otherwise, move onto state 4.
4. **Apply wild Pokemon's attack to your Pokemon** - randomly selects a move (from the same 4 moves you can choose from), and does the same calculations as state 3, except it's being applied to your Pokemon's HP. Afterwards, if your Pokemon's HP goes to 0, go to the **loss** state. Otherwise, go back to state 1.
5. **Heal** - raises your Pokemon's HP by exactly 5 points every time (no accuracy involved). Afterwards, go to state 4.
6. **Attempt Catch** - throw a Pokeball at the wild Pokemon. Success is calculated as follows:  a value between 0 and 15 is randomly calculated and compared to the wild Pokemon's HP. If the random value is greater than their HP, then the catch is successful, and you move onto the **Caught** state. Otherwise, the catch fails, and you move onto state 4.
     * Strategy: get the Pokemon's HP as low as possible to increase your chances of a successful catch!