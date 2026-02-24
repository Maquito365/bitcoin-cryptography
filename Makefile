## ─────────────────────────────────────────────────────────────────────────
##  Bitcoin Cryptography — Exercise Makefile
##
##  Usage
##  ─────
##  make ex1          compile & run Exercise 1 (HashUtil)
##  make ex2          compile & run Exercise 2 (ProofOfWork)
##  make ex3          compile & run Exercise 3 (Block)
##  make ex4          compile & run Exercise 4 (Blockchain)
##  make ex5          compile & run Exercise 5 (TransactionExercise)
##
##  make s1           compile all of Session 1 at once
##  make s2           compile Session 2
##
##  make clean        delete all compiled .class files
##  make help         show this message
##
##  How the classpaths work
##  ───────────────────────
##  Session 1 files compile into out/session1/
##  Session 2's TransactionExercise is standalone — no -cp dependency on session1.
##  The solutions folder is compiled with both on its -cp.
## ─────────────────────────────────────────────────────────────────────────

JC     = javac
JAVA   = java
S1SRC  = session1
S2SRC  = session2
SOLSRC = solutions
S1OUT  = out/session1
S2OUT  = out/session2
SOLOUT = out/solutions

## ── Output directories ──────────────────────────────────────────────────

$(S1OUT) $(S2OUT) $(SOLOUT):
	mkdir -p $@

## ── Session 1 ────────────────────────────────────────────────────────────

$(S1OUT)/HashUtil.class: $(S1SRC)/HashUtil.java | $(S1OUT)
	$(JC) -d $(S1OUT) $(S1SRC)/HashUtil.java

$(S1OUT)/ProofOfWork.class: $(S1SRC)/ProofOfWork.java $(S1OUT)/HashUtil.class | $(S1OUT)
	$(JC) -cp $(S1OUT) -d $(S1OUT) $(S1SRC)/ProofOfWork.java

$(S1OUT)/Block.class: $(S1SRC)/Block.java $(S1OUT)/HashUtil.class | $(S1OUT)
	$(JC) -cp $(S1OUT) -d $(S1OUT) $(S1SRC)/Block.java

$(S1OUT)/Blockchain.class: $(S1SRC)/Blockchain.java $(S1OUT)/Block.class | $(S1OUT)
	$(JC) -cp $(S1OUT) -d $(S1OUT) $(S1SRC)/Blockchain.java

## ── Session 2 ────────────────────────────────────────────────────────────

$(S2OUT)/TransactionExercise.class: $(S2SRC)/TransactionExercise.java | $(S2OUT)
	$(JC) -d $(S2OUT) $(S2SRC)/TransactionExercise.java

## ── Solutions ────────────────────────────────────────────────────────────

$(SOLOUT)/Solutions.class: $(SOLSRC)/Solutions.java | $(SOLOUT)
	$(JC) -cp $(S1OUT):$(S2OUT) -d $(SOLOUT) $(SOLSRC)/Solutions.java

## ── Convenience targets: compile + run ───────────────────────────────────

.PHONY: ex1 ex2 ex3 ex4 ex5 s1 s2 solutions clean help

ex1: $(S1OUT)/HashUtil.class
	$(JAVA) -cp $(S1OUT) HashUtil

ex2: $(S1OUT)/ProofOfWork.class
	$(JAVA) -cp $(S1OUT) ProofOfWork

ex3: $(S1OUT)/Block.class
	$(JAVA) -cp $(S1OUT) Block

ex4: $(S1OUT)/Blockchain.class
	$(JAVA) -cp $(S1OUT) Blockchain

ex5: $(S2OUT)/TransactionExercise.class
	$(JAVA) -cp $(S2OUT) TransactionExercise

## ── Bulk compile targets ─────────────────────────────────────────────────

s1: $(S1OUT)/HashUtil.class $(S1OUT)/ProofOfWork.class \
    $(S1OUT)/Block.class $(S1OUT)/Blockchain.class
	@echo "Session 1 compiled OK → $(S1OUT)/"

s2: $(S2OUT)/TransactionExercise.class
	@echo "Session 2 compiled OK → $(S2OUT)/"

solutions: s1 s2 $(SOLOUT)/Solutions.class
	@echo "Solutions compiled OK → $(SOLOUT)/"

## ── Clean ────────────────────────────────────────────────────────────────

clean:
	rm -rf out
	@echo "Cleaned."

## ── Help ─────────────────────────────────────────────────────────────────

help:
	@echo ""
	@echo "  make ex1 .. ex4   Session 1 exercises"
	@echo "  make ex5          Session 2 exercise"
	@echo "  make s1           compile all of Session 1"
	@echo "  make s2           compile Session 2"
	@echo "  make clean        remove compiled output"
	@echo ""
