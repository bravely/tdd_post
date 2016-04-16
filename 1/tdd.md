# TDD Done Right

**Before we get started: TDD stands for "Test Driven Development", and is most closely associated with the practice, "Red, Green, Refactor"- i.e., write your tests for what you want the eventual code to do, write code to fulfill said tests, then refactor said code into final form if needed.**

TDD is one of those nasty subjects that it seems so many people have an opinion of, but is still constantly recommended. Admittedly, I'm part of the latter. Why?

TDD to me is less about testing itself- I trust myself and my coworkers to write tests, and even if I didn't pay attention I'm pretty sure our coverage would stay above 90%. But there are several benefits, some obvious, and some less obvious, that make TDD indispensable for me:

### Tests function as documentation.
They tell you exactly what every object, function, and class is supposed to do, and guarantee that they do it(since it passes). This is obviously helpful in the case of ramping up new team members, but also can be helpful in returning to an ancient codebase.

### TDD leads to better code quality.
This is accomplished easier than you think- primarily through simply writing *less* code. But even if this is ignored, TDD makes it easier to follow the spec your code should live up to, and in turn, to guarantee you fulfill that spec.

### It lets you be more cavalier when jumping into old code.
Inevitably, you're going to be going over old code, and breaking things. If you know it's tested thoroughly, you can implement the tests for what you want, and then simply run the rest of the test suite to see what else is broken, as soon as you get your new code working. It's a safety net, a great big one, and one of the biggest things that both speeds up my development and decreases my anxiety(which is considerable).

### TDD leads to better API design.
How? Well, primarily because when writing your tests, you should think of everything in a three-step process.

1. **What do I want this to do?** This seems obvious, but often there are side effects to everything in programming. Sometimes, they're even intended. Don't think of how you'll implement this- *only* think of what it accomplishes.
2. **What are the minimum required pieces to accomplish this?** Do you need anything at all? If you do, do you usually find that attached to an object? Does that one object have everything required, or is everything attached to that object? Try to minimize what is required for the piece of code you're creating to have to 'pick up', that way it's easier to design around.
3. **What's the easiest way to use this?** This is what you're designing around. This is the whole thing: The difference between a good programmer(whether they follow TDD or not) and not. Easy to understand/use code is good code. The two previous steps were to deliver you here- and you've not thought of implementation details yet at all. Keep it that way. You'll write better code.

## "That's all great" I hear you saying. "But so many people hate it, why?"

Well, because programmers are nothing if not creatures of process, and TDD is not a strict process, and should never be obeyed as one. Sometimes, you simply don't know how to accomplish what you're looking to do, so you don't know what it requires. Maybe it's a huge project, and you don't know where to start. Maybe you don't know what the conventions are for the tests you're going to write, and are afraid you're going to miss something(probably).

There are many more concerns, and they're all valid. But honestly, a lot of it comes down to how much of a moral position so many TDD-enthusiasts make it out to be. It isn't. It might help you code better, it might not. But it is a firm, well-trodden way that might make you code better, and almost certainly won't make you code any worse.

So, lets start.

### First things first: Do you have any idea what you're doing?

It's okay to say no. I often don't. Maybe you're integrating another technology/service, and you don't know what kind of responses it gives you, or what it requires of you. Maybe you don't know if the code you've been handed to add something onto even works. Maybe you're building for a spec that hasn't been finalized, and you would rather define it now than get into an arguing match with another team later. In this case, you're not quite at the point where you can really implement anything, are you? In the process, you haven't arrived at TDD quite yet. You still have to research.

Researching ends up being a lot of frustration in search of the ah-ha moment, but in general, you want to follow this idea:

##### If I can do it by hand, I can implement it later.

If your language has an interpreter, this is the time to use it. I often hop into my interpreter and go, by hand, through the entirety of what I want to create. In the past, this has included building an API endpoint that contacted AWS, spun up a new server, recorded that data in our DB, and checked for when it was fully booted. This was a 6 step process overall(AWS EC2 needs real simplification), and half of the pieces I'd never tried before. Doing it by hand helped me understand exactly what I was doing, explore each API endpoint and the totality of the data I was given.

If you don't have an interpreter, obviously you'll have to write some code to a file. Here you'll probably have much more work to go through, importing everything you need into the file to get it going. Try to make sure nothing of what you do in this file is permanent. If possible, try writing any data you need to store straight as binary to a file next to the one you're writing this in. It'll make it easier to parse exactly what's going on, and worst case scenario, you yank it back in for future runs to manipulate it.

##### Okay, so you know what you're doing. Where do I get started?

Well, most of my experience right now is in Ruby, dealing with the Rails framework. So lets build us some examples. We'll start with model tests.

# model_specs.rb gist goes here

One thing to also learn from the above example: Anytime it isn't plainly clear what the test sets out to prove, we specifically say so in the `it` block. This is one of your primary places of documentation in tests. Documentation in specs is important to help remember original intent of code, which if well-written can save a lot of headache when coming back months later.
