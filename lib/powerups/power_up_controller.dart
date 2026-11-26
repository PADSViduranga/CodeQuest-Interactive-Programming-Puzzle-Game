class PowerUpController {
  int lives = 3;
  bool timerFrozen = false;
  bool skipUsed = false;
  bool fiftyFiftyUsed = false;
  bool freezeUsed = false;
  bool extraLifeUsed = false;

  void useSkip() {
    if (skipUsed) throw StateError('Skip has already been used.');
    skipUsed = true;
  }

  void useFiftyFifty() {
    if (fiftyFiftyUsed) throw StateError('50/50 has already been used.');
    fiftyFiftyUsed = true;
  }

  void useFreeze() {
    if (freezeUsed) throw StateError('Freeze timer has already been used.');
    freezeUsed = true;
    timerFrozen = true;
  }

  void unfreeze() => timerFrozen = false;

  void useExtraLife() {
    if (extraLifeUsed) throw StateError('Extra life has already been used.');
    extraLifeUsed = true;
    lives++;
  }

  bool loseLife() {
    lives--;
    return lives <= 0;
  }
}
