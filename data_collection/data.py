# Lasse Nordahl - 89502635 - lnordahl

# https://stackoverflow.com/questions/510357/python-read-a-single-character-from-the-user

import collections
import random
random.seed(0)

TASK_TYPES = [
    "academic",
    "personal",
    "work",
    "exercise",
    "meeting",
    "flex"
]

TASK_LENGTHS = [
    1,
    2,
    3
]

HOURS_IN_DAY = 24
SLEEPING_HOURS = 8
CLASS_HOURS = 6
AVAILABLE_HOURS = HOURS_IN_DAY - SLEEPING_HOURS - CLASS_HOURS
# 0 is 12AM, 11 is 11AM, and 23 is 11PM
TIMES_OF_DAY = [x for x in range(HOURS_IN_DAY)]
CLASSES_START = 11
CURRENT_TAKEN_TIMESLOTS = [
    *[x for x in range(SLEEPING_HOURS)], *[x + CLASSES_START for x in range(CLASS_HOURS)]]
CURRENT_OPEN_TIMESLOTS = [
    x for x in range(HOURS_IN_DAY) if x not in CURRENT_TAKEN_TIMESLOTS]
TIME_DIFFERENCES = collections.defaultdict(list)

TASK_DESCRIPTIONS = {
    TASK_TYPES[0]: [
        "Study at Langson",
        "Study at Science Library",
        "Study for CS125 Midterm at Pheonix Grill",
        "Study for CS178 Midterm at ALP"
    ],
    TASK_TYPES[1]: [
        "Call mom",
        "Call dad",
        "Go to dinner with roommates"
    ],
    TASK_TYPES[2]: [
        "Work at DBH",
        "Work at Anteatery"
    ],
    TASK_TYPES[3]: [
        "Work out at ARC",
        "Go for a run",
        "Go rock climbing"
    ],
    TASK_TYPES[4]: [
        "HackUCI club meeting",
        "Photography club meeting",
    ],
    TASK_TYPES[5]: [
        "flex"
    ]
}


class _GetchUnix:
    def __init__(self):
        import tty
        import sys

    def __call__(self):
        import sys
        import tty
        import termios
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            ch = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return ch


def calculate_time_differences():
    for x in CURRENT_OPEN_TIMESLOTS:
        num = x
        count = 1
        while True:
            num = (num + 1) if num < 23 else 0
            count += 1
            if num in CURRENT_TAKEN_TIMESLOTS:
                TIME_DIFFERENCES[count - 1].append(x)
                break


def format_time(number):
    modded_number = number % 12
    if (modded_number == 0):
        return "12AM" if number < 12 else "12PM"
    else:
        return str(modded_number) + ("AM" if number < 12 else "PM")


def get_random_value(values):
    length = len(values)
    return values[random.randint(0, length - 1)]


def find_time(task_length):
    possible_times = [time for available_time, times in TIME_DIFFERENCES.items(
    ) if available_time >= task_length for time in times]
    if len(possible_times) == 0:
        return -1
    else:
        return get_random_value(possible_times)


def generate_random_task():
    task_data = []

    # Pick random length
    task_length = random.randrange(1, 4)
    task_data.append(task_length)

    # Select random time
    task_time = find_time(task_length)
    task_data.append(task_time)

    # Add Formatted Time
    task_data.append(format_time(task_time))

    # Select a random description
    task_type = get_random_value(TASK_TYPES)
    task_data.append(task_type)

    task_description = get_random_value(TASK_DESCRIPTIONS[task_type])
    task_data.append(task_description)

    return task_data

def get_answer():
    get = _GetchUnix()
    returnChar = ''
    while (True):
        returnChar = get().lower()
        if (returnChar != 'y' or returnChar != 'n'):
            if (returnChar == 'q'):
                break
            else:
                print("Invalid input")
        else:
            return 1 if returnChar == 'y' else 0
    return -1


def run_data_script():
    for i in range(500):
        print(generate_random_task())


if __name__ == "__main__":
    calculate_time_differences()
    run_data_script()
