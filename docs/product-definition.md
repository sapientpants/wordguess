# WordGuess Game - Product Definition

## Overview
A single-user implementation of the classic word guessing game built with Phoenix LiveView, styled with Tailwind CSS and DaisyUI components.

## Technology Stack
- **Backend**: Elixir, Phoenix Framework
- **Frontend**: Phoenix LiveView for real-time interactivity
- **Styling**: Tailwind CSS with DaisyUI component library
- **Database**: PostgreSQL (minimal usage for word storage, game statistics)

## Core Features

### Game Mechanics
- Random word selection from a curated dictionary
- Word guessing gameplay with limited incorrect guesses allowed
- Real-time feedback on guessed letters
- Visual incorrect guess counter that updates with each wrong guess
- Game state persistence (optional save/resume functionality)

### User Interface Components
- Clean, responsive design using DaisyUI components
- Animated incorrect guess visualization using SVG
- On-screen keyboard for letter input (also supports physical keyboard)
- Game status display (guessed letters, remaining attempts)
- Word display with placeholders for unguessed letters
- Win/loss modals with game statistics and replay option

### User Experience Flow
1. Home page with "Start Game" button and optional difficulty selection
2. Game view with incorrect guess counter, word progress, and keyboard
3. Real-time updates as player makes guesses (no page refreshes)
4. End-game screen with win/loss message and statistics
5. Option to play again or return to home

### Additional Features (Phase 2)
- Difficulty levels (easy/medium/hard word lists)
- Game statistics tracking (wins, losses, average guesses)
- Word definitions displayed after game completion
- Custom word lists or categories
- Theme customization using DaisyUI themes
- Hint system with limited usage per game

## Technical Implementation Notes
- Leverage Phoenix LiveView for real-time UI updates without JavaScript
- Use Tailwind utility classes for responsive design
- Implement DaisyUI components for consistent UI elements
- Store game state in LiveView process for seamless experience
- Design modular components for easy maintenance and extension