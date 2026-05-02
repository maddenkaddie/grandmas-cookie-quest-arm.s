.global main

@ Kaddie Madden
@ ARM Assembly Text Adveture Game
@ Deliver the cookies to Grandma while surviving the forest.


@ Game introduction and player name input
main:
        MOV r4, #3      @ Lives = 3

        LDR r0, =intro
        BL printf
        LDR r0, =namePrompt
        BL printf
        LDR r0, =nameFormat
        LDR r1, =playerName
        BL scanf

@ Enchanted Forest - first story choice
enchantedForest:
        LDR r0, =forestFork
        LDR r1, =playerName
        BL printf
        
        LDR r0, =choiceFormat
        LDR r1, =choice
        BL scanf

        LDR r1, =choice
        LDRB r1, [r1]

        CMP r1, #'1'
        BEQ godzillaPath

        CMP r1, #'2'
        BEQ candyLand

        CMP r1, #'3'
        BEQ fireSwamp

        LDR r0, =invalidChoiceText
        BL printf

        B enchantedForest

@ Godzilla Shortcut - easy win
godzillaPath:
        LDR r0, =godzillaText
        BL printf

        B successEnding

@ Candy Land path
candyLand:
        LDR r0, =candyForkText
        BL printf

        LDR r0, =choiceFormat
        LDR r1, =choice
        BL scanf

        LDR r1, =choice
        LDRB r1, [r1]
        
        CMP r1, #'1'
        BEQ candyCanePath

        CMP r1, #'2'
        BEQ gumdropPath

        LDR r0, =invalidChoiceText
        BL printf

        B candyLand

candyCanePath:
        LDR r0, =candyCaneText
        BL printf

        B seagullZone

gumdropPath:
        LDR r0, =gumdropText
        BL printf
        BL loseLife

        B seagullZone

@ Fire Swamp path
fireSwamp:
        LDR r0, =swampForkText
        BL printf

        LDR r0, =choiceFormat
        LDR r1, =choice
        BL scanf

        LDR r1, =choice
        LDRB r1, [r1]

        CMP r1, #'1'
        BEQ lightningSand

        CMP r1, #'2'
        BEQ rodentFight

        LDR r0, =invalidChoiceText
        BL printf

        B fireSwamp

lightningSand:
        LDR r0, =lightningSandText
        BL printf
        BL loseLife

        B seagullZone

rodentFight:
        LDR r0, =rodentText
        BL printf
        BL loseLife

        B seagullZone

@ Lost one life and display remaing lives
loseLife:
        PUSH {lr}

        SUB r4, r4, #1
        LDR r0, =livesText
        MOV r1, r4
        BL printf

        CMP r4, #0
        BEQ gameOver

        POP {lr}
        BX lr

loseLifeGameOver:
        POP {lr}
        
        B gameOver

@ Critical hit -two lives
loseTwoLives:
        PUSH {lr}

        SUB r4, r4, #2
        LDR r0, =livesText
        MOV r1, r4
        BL printf

        CMP r4, #0
        BEQ loseTwoGameOver

        POP {lr}
        BX lr

loseTwoGameOver:
        POP {lr}

        B gameOver

@ Seagull critical area
seagullZone:
        LDR r0, =seagullForkText
        BL printf

        LDR r0, =choiceFormat
        LDR r1, =choice
        BL scanf

        LDR r1, =choice
        LDRB r1, [r1]
        CMP r1, #'1'
        BEQ runUnderTrees

        CMP r1, #'2'
        BEQ bombSeagull

        LDR r0, =invalidChoiceText
        BL printf

        B seagullZone

runUnderTrees:
        LDR r0, =runTreesText
        BL printf

        B finalFork

bombSeagull:
        LDR r0, =bombSeagullText
        BL printf
        BL loseTwoLives

        B finalFork

@ Last Task to complete
finalFork:
        LDR r0, =finalForkText
        BL printf

        LDR r0, =choiceFormat
        LDR r1, =choice
        BL scanf

        LDR r1, =choice
        LDRB r1, [r1]

        CMP r1, #'1'
        BEQ runToGrandma

        CMP r1, #'2'
        BEQ walkCarefully

        LDR r0, =invalidChoiceText
        BL printf

        B finalFork

runToGrandma:
        LDR r0, =runGrandmaText
        BL printf

        B successEnding
walkCarefully:
        LDR r0, =walkCarefullyText
        BL printf
        BL loseLife

        B successEnding

@ Ending logic based on lives remaining
successEnding:
        CMP r4, #3
        BEQ perfectEnding

        CMP r4, #2
        BEQ goodEnding

        CMP r4, #1
        BEQ barelyEnding

        B gameOver

perfectEnding:
        LDR r0, =perfectEndingText
        LDR r1, =playerName
        BL printf

        B endProgram

goodEnding:
        LDR r0, =goodEndingText
        LDR r1, =playerName
        BL printf

        B endProgram

barelyEnding:
        LDR r0, =barelyEndingText
        LDR r1, =playerName
        BL printf

        B endProgram

gameOver:
        LDR r0, =gameOverText
        BL printf

        B endProgram

@ Replay/Quit menu
endProgram:
        LDR r0, =playAgainText
        BL printf
        
        LDR r0, =choiceFormat
        LDR r1, =choice
        BL scanf
        LDR r1, =choice
        LDRB r1, [r1]

        CMP r1, #'1'
        BEQ main

        CMP r1, #'2'
        BEQ quitProgram

        LDR r0, =invalidChoiceText
        BL printf

        B endProgram

quitProgram:
        MOV r0, #0
        BL exit

.data

intro:
        .asciz "\nCookies, Chaos, and the Fire Swamp!\nYou must deliver cookies to Grandma's house.\nLives 3\n\n"

namePrompt:
        .asciz "Enter your name please: "

nameFormat:
        .asciz "%s"

choiceFormat:
        .asciz "%s"

forestFork:
        .asciz "\n%s enters the Enchanted Forest:\nThe cookie basket is warm, but the trees are whispering.\n\n1) Follow the giant footprints\n2) Take the sparking candy path\n3) Enter the smoky Fire Swamp path\nChoose 1, 2, or 3: "

godzillaText:
        .asciz "\nYou hear giant footsteps...\nIt's Godzilla!\nBut he's nice and carries you closer to Grandma's house.\n"

candyForkText:
        .asciz "\nYou step into Candy Land. Everything smells like sugar and bad decisions.\n\n1) Candy Cane Forest\n2) Gumdrop Mountain\nChoose: "

candyCaneText:
        .asciz "\nThe candy canes point towards Grandma's house. YOu follow the peppermint trail safely.\n"

gumdropText:
        .asciz "\nYou slip on Gumdrop Mountain and fall straight into Fudge River.\n-1 life\n"

swampForkText:
        .asciz "\nYOu enter the Fire Swamp. The gound hisses beneath your feet.\n\n1) Step onto the soft ground\n2) Follow the narrow trail\nChoose: "

lightningSandText:
        .asciz "\nThe soft ground was Lightning Sand! You sink and barely pull yourself out.\n-1 life\n"

rodentText:
        .asciz "\nA Rodent of Unusual Size appears. You fight it off, but not without a scratch.\n-1 life\n"

seagullForkText:
        .asciz "\nYou hear screeching above you.\n1) Run under the trees\n2) Look up\nChoose: "

runTreesText:
        .asciz "\nYou sprint under the trees and dodge whatever chaos was above you.\n"

bombSeagullText:
        .asciz "\nA seagull swoops down, eats a bomb hotdog, and explodes.\nCritical hit. \n-2 life\n"

finalForkText:
        .asciz "\nGrandma's house is finally in sight.\n1) Run to the door\n2) Walk carefully\nChoose: "

runGrandmaText:
        .asciz "\nYou run to Grandma's door with the cookie basket bouncing in your arms.\n"

livesText:
        .asciz "Lives remaining: %d\n"

perfectEndingText:
        .asciz "\n%s, you made it to Grandma's house with all 3 lives left!\nThe cookies are warm, perfect, and Grandma is very impressed!\n"

goodEndingText:
        .asciz "\n%s, you made it to Grandma's house with 2 lives left.\nYou are a bit beat up but otherwise okay and the cookies made it.\n"

barelyEndingText:
        .asciz "\n%s, you made it to Grandma's house with only 1 life left.\nYou have cold cookies and grandma is not impressed.\nYou look like you've been through it and you will be finding other means to get back home.\n"

walkCarefullyText:
        .asciz "\nYou walk carefully through the forest....\nA cute bunny hops towards your basket.\nBefore you can react, it swaps one of your cookies for dynamite.\nBOOM.\n-1 life\n"

gameOverText:
        .asciz "\nYou ran out of lives. The cookies never made it and neither did you. You failed. womp. womp.\n"
invalidChoiceText:
        .asciz "\nInvalid choice. Please enter one of the listed numbers.\n"

playAgainText:
        .asciz "\nPlay again?\n1) Yes\n2) No\nChoose: "

choice:
        .space 10

playerName:
        .space 40

