Group Members:
Mark Davydov 1000816110
Harshdeep Grewal 1002543376
Omid Najmeddini 1002358441
Shaoyang Meng 1002671469

https://github.com/MarkDavydov/B58PaintBook
https://www.youtube.com/watch?v=EWo3X-iGeuE&feature=youtu.be

PaintBook project

Note that in the github link, project.v is the working product that we showed, while project2.v is what we tried to get working in lab3.

Overview:
Our final product allows the user to draw a picture on a 160/120 resolution background.

Details:
PaintBook starts with one pixel in the middle of the screen.
The user can draw by using keys0-3 to move left, up, down, and right respectively.
This essentially draws lines on the black background that can be used to make a picture.
There are also a few useful switches that make it a little easier to draw a good picture:
SW[1] = Write enable (The user can turn this switch off if they wish to move the cursor without drawing)
SW[7-9] = Colour (The user can use any combination of these 3 switches to cycle through 8 different colours)
SW[15] = Erase (If the user makes a mistake in their drawing, they can use this switch to erase over their mistake)


Challenges:
One major problem we have with our application is that it is hard for the user to know the location of the pixel they are currently drawing on.
Other drawing applications usually solve this issue by having some sort of pencil or flashing cursor that follows the location you are drawing on.
The reason we could not implement this type of solution is because the cursor would have to constantly be erased, but if we erased in black we could
potentially be erasing part of the users picture. Therefore, we would have to erase in the same colour of the pixel that was previously in the location of the cursor,
and we don't know how to aquire this information in varilog.

Due to this, we came up with a different solution that we tried to implement in lab3. We decided we would create a black border along the x and y axis of the monitor.
Then, as the user is drawing, there would be two cursors, an x and a y cursor, that would show the x and the y location the user is currently drawing in.
The reason this solutions works is that we know the background of the borders will always be black, and therefore we can constantly erase these cursors with black.
We tried to implement this in lab3, and feel that we were very close, but we had some issues with the drawing location bouncing to the cursor location that we couldn't quite debug in time.
