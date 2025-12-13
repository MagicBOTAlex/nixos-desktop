{ pkgs, inputs, lib, ... }:
{
  programs.plasma.hotkeys.commands = {
    "ydotool-up" = {
      name = "Keyboard move mouse up fast";
      key = "Meta+Ctrl+Up";
      command = "ydotool mousemove -x 0 -y -100";
    };
    "ydotool-down" = {
      name = "Keyboard move mouse down fast";
      key = "Meta+Ctrl+Down";
      command = "ydotool mousemove -x 0 -y 100";
    };

    "ydotool-left" = {
      name = "Keyboard move mouse left fast";
      key = "Meta+Ctrl+Left";
      command = "ydotool mousemove -x -100 -y 0";
    };
    "ydotool-right" = {
      name = "Keyboard move mouse right fast";
      key = "Meta+Ctrl+Right";
      command = "ydotool mousemove -x 100 -y 0";
    };

    "ydotool-up-fast" = {
      name = "Keyboard move mouse up slow";
      key = "Meta+Ctrl+Shift+Up";
      command = "ydotool mousemove -x 0 -y -10";
    };
    "ydotool-down-fast" = {
      name = "Keyboard move mouse down slow";
      key = "Meta+Ctrl+Shift+Down";
      command = "ydotool mousemove -x 0 -y 10";
    };
    "ydotool-left-fast" = {
      name = "Keyboard move mouse left slow";
      key = "Meta+Ctrl+Shift+Left";
      command = "ydotool mousemove -x -10 -y 0";
    };
    "ydotool-right-fast" = {
      name = "Keyboard move mouse right slow";
      key = "Meta+Ctrl+Shift+Right";
      command = "ydotool mousemove -x 10 -y 0";
    };


    "ydotool-left-click" = {
      name = "Keyboard mouse left click";
      key = "Print";
      command = "ydotool click 0xC0";
    };
    "ydotool-right-click" = {
      name = "Keyboard mouse right click";
      key = "Menu";
      command = "ydotool click 0xC1";
    };


  };
}
