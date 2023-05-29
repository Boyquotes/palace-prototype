extends Node

enum UNIT_STATES {IDLE, RUNNING, IN_AIR, AT_WALL, HIT, WINDUP}
enum ACTION_TYPES {MOVEMENT, ATTACK, SKILLS}

# each AI determines what the actions mean
enum ENEMY_ACTIONS {MOVE, ATTACK}
