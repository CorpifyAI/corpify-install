# Block 04 — Business Discovery

## What this is

A workflow for using your corporation to **find profitable niches** when you don't know what business to start, or to **validate** an idea before you invest time.

It's not a separate tool — it's how the CEO + Market Researcher + AI Scout cooperate to give you a shortlist.

## When to use this

- You want to start a business but don't have a specific idea
- You have a vague idea and want to test it
- You're considering a pivot from your current direction
- You want to map a new market for an expansion

## How to ask the CEO

Open VS Code → Claude Code panel. Type one of these (adjust to your situation):

### Pattern 1 — "Find me a niche"

```
@corp-ceo I want to start an online business in 2026. 
My budget is $500/month. I can spend 10 hours/week. 
I have skills in [your skills, e.g. "writing, basic Python, design"].
Find me 5-10 profitable niches that fit. For each, show:
- Why it's promising (market size, growth, signals)
- Why it fits me specifically
- What I'd build in the first 30 days
- Realistic revenue path
```

The CEO will:
1. Apply Rule 1 (search GitHub for existing tools that could be a starting point)
2. Dispatch Market Researcher for market data
3. Dispatch AI Scout for trend signals
4. Return a ranked shortlist with reasoning

### Pattern 2 — "Validate my idea"

```
@corp-ceo I'm thinking about [your idea, e.g. "selling AI-generated 
children's books on Etsy"]. Help me evaluate:
- Is this market real and growing?
- Who's already winning here? (competitor scan)
- What's the realistic 90-day path?
- What are the 3 biggest risks?
- Should I proceed, pivot, or pass?
```

### Pattern 3 — "Pick between options"

```
@corp-ceo I'm choosing between:
A) [option A with rough description]
B) [option B with rough description]
C) [option C with rough description]
Which one fits me best given my constraints: [constraints]
Give me a decision matrix and your recommendation.
```

## What good output looks like

The CEO should return something like:

```
TOP 3 NICHE RECOMMENDATIONS

1. [Niche name]
   Why now: [data]
   Why you: [fit reasoning]
   30-day plan: [concrete steps]
   Realistic revenue path: $X by month 3, $Y by month 6
   Open-source tools that help: [from Rule 1 search]
   Risks: [top 3]
   Score: 8.5/10

2. [Niche name]
   ...

3. [Niche name]
   ...

MY RECOMMENDATION
[Single pick with reasoning + suggested first action]

NEXT STEP
"Should I draft a 30-day plan for niche #1?"
```

## When you pick one

Reply:
```
@corp-ceo Go with niche #1. Draft a 30-day execution plan with 
specific tasks, who owns each, and what success looks like at day 30.
```

The CEO will:
- Create a project in AI Team OS
- Form a team (Sales, Marketing, Lawyer if needed, Engineering if needed)
- Break the plan into concrete tasks
- Save the decision to Archivarius

## Tips

- **Don't ask abstract questions** ("how do I make money") — give context
- **Be honest about your constraints** (time, money, skills, location)
- **Trust the corporation to disagree with you** — that's the value
- **Save important findings** ("Archivarius, save the top 3 niches we analyzed today")

## What this is NOT

- Not investment advice (CEO is an AI, not a registered advisor)
- Not a guarantee — markets shift, ideas fail, work happens
- Not a substitute for talking to real customers in your chosen niche

CEO points you at promising starting positions. You still have to play the game.
