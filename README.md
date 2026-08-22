# Habit Tracker

A single-page habit tracker for habits that aren't daily.

Most habit trackers assume "every day" and treat anything less as a broken
streak. This one is built around frequency instead — set a habit to 3x/week,
2x/week, or whatever actually fits, and your streak is measured against that
target instead of against every single day. It's picked up ~30 users so far,
all by word of mouth.

## Features

- Set a target frequency per habit (daily down to 1x/week)
- Streaks calculated against that frequency, not a daily on/off
- Weekly grid view + a monthly calendar view
- Tags for grouping habits
- Weekly review notes
- A weekly bar chart summarizing completions

## How it's built

One HTML file. No backend, no build step, no dependencies — everything
(habits, completions, tags, notes) is stored in the browser's `localStorage`.
Open the file and it works.

## Running it

Just open `Habit Tracker.html` in a browser. There's nothing to install.

## Status

Actively used, actively maintained based on what I actually want out of it
day to day.
