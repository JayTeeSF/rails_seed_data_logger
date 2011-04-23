Not much.
It started from a simple one line hack to track object.save events
...then I wanted object.update_attribute events
and eventually I'll want deletes (destroys)

This way I can replay the log in script/console
And now I can use my app to more easily generate seed-data
