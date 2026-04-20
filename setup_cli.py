#!/usr/bin/env python3
"""
macOS Tahoe Setup CLI
Interactive setup tool for macOS Tahoe with support for batch or individual installation
"""

import subprocess
import sys
from typing import List, Dict
from dataclasses import dataclass

@dataclass
class Task:
    """Represents a setup task"""
    name: str
    description: str
    func: callable

class SetupManager:
    """Manages all macOS setup tasks"""

    def __init__(self):
        self.tasks: Dict[str, Task] = {
            "xcode": Task(
                name="Install XCode Tools",
                description="Command line tools for Xcode",
                func=self.install_xcode_tools
            ),
            "brew": Task(
                name="Install Brew",
                description="Package manager for macOS",
                func=self.install_brew
            ),
            "defaults": Task(
                name="Apply macOS Defaults",
                description="Optimize macOS system settings",
                func=self.apply_macos_defaults
            ),
            "zsh": Task(
                name="Install Zsh",
                description="Z shell (improved shell)",
                func=self.install_zsh
            ),
            "ohmyposh": Task(
                name="Install Oh-My-Posh",
                description="Prompt theme engine",
                func=self.install_oh_my_posh
            ),
            "brew_apps": Task(
                name="Install Applications via Brew",
                description="Install curated applications",
                func=self.install_brew_applications
            ),
        }

    def run_command(self, cmd: List[str], description: str = "") -> bool:
        """Execute shell command with error handling"""
        try:
            result = subprocess.run(cmd, check=True, capture_output=True, text=True)
            if description:
                print(f"✓ {description}")
            return True
        except subprocess.CalledProcessError as e:
            print(f"✗ Failed: {description or ' '.join(cmd)}")
            if e.stderr:
                print(f"  Error: {e.stderr.strip()}")
            return False
        except Exception as e:
            print(f"✗ Error: {e}")
            return False

    def install_xcode_tools(self) -> bool:
        """Install XCode command line tools"""
        print("\n📦 Installing XCode Tools...")
        return self.run_command(
            ["xcode-select", "--install"],
            "XCode Tools installation initiated"
        )

    def install_brew(self) -> bool:
        """Install Homebrew package manager"""
        print("\n📦 Installing Brew...")
        brew_install_cmd = (
            '/bin/bash -c "$(curl -fsSL '
            'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        )
        try:
            subprocess.run(brew_install_cmd, shell=True, check=True)
            print("✓ Brew installed successfully")
            return True
        except subprocess.CalledProcessError:
            print("✗ Failed to install Brew")
            return False

    def apply_macos_defaults(self) -> bool:
        """Apply macOS system defaults"""
        print("\n📦 Applying macOS Defaults...")
        print("⚠️  macOS Defaults configuration - Coming soon")
        # TODO: Define macOS system defaults
        return True

    def install_zsh(self) -> bool:
        """Install Zsh shell"""
        print("\n📦 Installing Zsh...")
        return self.run_command(
            ["brew", "install", "zsh"],
            "Zsh installed successfully"
        )

    def install_oh_my_posh(self) -> bool:
        """Install Oh-My-Posh prompt theme engine"""
        print("\n📦 Installing Oh-My-Posh...")
        return self.run_command(
            ["brew", "install", "jandedobbeleer/oh-my-posh/oh-my-posh"],
            "Oh-My-Posh installed successfully"
        )

    def install_brew_applications(self) -> bool:
        """Install curated applications via Brew"""
        print("\n📦 Installing Applications via Brew...")
        print("⚠️  Brew applications installation - Coming soon")
        # TODO: Define list of applications to install
        return True

    def display_menu(self):
        """Display interactive menu"""
        print("\n" + "=" * 60)
        print("🚀 macOS Tahoe Setup CLI")
        print("=" * 60)
        print("\nAvailable tasks:")
        for i, (key, task) in enumerate(self.tasks.items(), 1):
            print(f"  {i}. {task.name:<30} - {task.description}")
        print(f"  {len(self.tasks) + 1}. Install All")
        print(f"  {len(self.tasks) + 2}. Exit")

    def get_user_selection(self) -> List[str]:
        """Get user selection from menu"""
        self.display_menu()
        print("\n" + "-" * 60)
        selection = input("Select tasks (comma-separated numbers, e.g., '1,3,5'): ").strip()

        if selection in [str(len(self.tasks) + 2), 'exit', 'q']:
            return []

        task_keys = list(self.tasks.keys())

        if selection == str(len(self.tasks) + 1):
            return task_keys

        try:
            selected_indices = [int(x.strip()) - 1 for x in selection.split(",")]
            selected_tasks = []
            for idx in selected_indices:
                if 0 <= idx < len(task_keys):
                    selected_tasks.append(task_keys[idx])
                else:
                    print(f"⚠️  Invalid selection: {idx + 1}")
            return selected_tasks
        except ValueError:
            print("⚠️  Invalid input. Please enter numbers separated by commas.")
            return self.get_user_selection()

    def execute_tasks(self, task_keys: List[str]) -> bool:
        """Execute selected tasks"""
        if not task_keys:
            print("\nNo tasks selected. Exiting...")
            return True

        print(f"\n{'=' * 60}")
        print(f"Executing {len(task_keys)} task(s)...")
        print(f"{'=' * 60}")

        for key in task_keys:
            task = self.tasks[key]
            try:
                task.func()
            except KeyboardInterrupt:
                print("\n\n⚠️  Setup interrupted by user")
                return False
            except Exception as e:
                print(f"✗ Unexpected error in {task.name}: {e}")
                return False

        print(f"\n{'=' * 60}")
        print("✓ Setup complete!")
        print(f"{'=' * 60}\n")
        return True

    def run(self):
        """Main entry point"""
        try:
            selected_tasks = self.get_user_selection()
            self.execute_tasks(selected_tasks)
        except KeyboardInterrupt:
            print("\n\n⚠️  Setup cancelled by user")
            sys.exit(1)
        except Exception as e:
            print(f"\n✗ Fatal error: {e}")
            sys.exit(1)


def main():
    """Entry point"""
    manager = SetupManager()
    manager.run()


if __name__ == '__main__':
    main()