from dataclasses import dataclass, field
from typing import List
from time import sleep
from signal import signal, SIGINT
from collections import Counter

def handle_sigint(signum, frame):
    """Method to handle CTRL + C nicely.

    Args:
        signum (Any): Signal Number
        frame (Any): Current Stack Frame
    """    
    print(glitch.mouth)
    exit(0)

@dataclass
class Glitch():
    """Class representing @glitchfur

    Returns:
        None
    """    
    class Mouth(Counter):
        """Subclass of collections.Counter for Glitch's mouth.

        Args:
            irrelivent, we always start with an empty mouth.
        """        
        def __str__(self) -> str:
            ate = list(map(lambda x: f'{x[1]} {x[0]}', dict(glitch.mouth).items()))
            return f"{__class__.__qualname__.split('.')[0]} has {' & '.join([', '.join(ate[: -1]), ate[-1]] if len(ate) > 2 else ate)} in their mouth."
    mouth: Mouth = field(default_factory=Mouth, init=False)
    def monch(self, thing: str):
        """Stuff something in Glitch's mouth.

        Args:
            thing (str): What you are stuffing in his mouth. (It's bread isn't it?)
        """        
        self.mouth[thing] += 1
        print(f'*Monches {thing}*')



if __name__ == "__main__":
    # Register the signal handler for SIGINT
    signal(SIGINT, handle_sigint)

    glitch = Glitch()

    while True:
        glitch.monch("Bread")
        sleep(1)
