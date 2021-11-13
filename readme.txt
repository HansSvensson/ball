
This file is obsolete

TODO:s:
------- 
* Draw nice charset
* Add music
  # Intro/menu
  # In game music
* Draw nice picture for intro
* Add animations then bricks break
* Add game modes:
  # Time limited match 60 sec, 90 sec
  # Until all bricks ended
* Score calculation
* Display score
* Intro, maybe scroller describing how to play
* Outro, Declaring winner.
* Some different levels to play
* Bonus bricks
  x Your paddle becomes bigger
  x Opponents paddle becomes smaller
  x Your balls becomes faster
  x ..
* Balls should be owned by bat. If Bat misses ball
  and ball changes side, owner should switch.
* Possibility to disturb opponent....
* Ball should go faster after the bat hit the ball.


BUG:s
------
* Obviously collision
* Sprites maybe needed to be updated all at once, end of frame
* Backwards jump at y=255.


CHARSET
-------
* Drawn with VCHAR64 (because ported to MAC).
* Multicolor
    Background       - D021         (Fixed) 
    Foreground       - COLOR RAM    (Changeable per char)
    Multicolor #1    - D022         (Fixed)
    Multicolor #2    - D023         (Fixed)

* Bricks drawn with:            102
* Bricks that break at once     64    (65-71 is reserved for animation then they break)
* Bricks that handles many hits 72-87
* Electric effect:              96-97
