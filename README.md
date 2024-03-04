# My Monorepo Attempt

The whole purpose of this repo is to figure out how to create an ideal
development environment using Docker. While monorepos are not always the
best tool for the job, they do provide some benefits. Unfortunatley, those
benefits come with some infrastructure complexity -- tradeoffs. Adding Docker
into the mix has proven to be even more challenging.

So how do we solve a complex problem? We break it down. And that's exactly
what we are going to be doing here. The plan is to start with a basic setup
using only npm workspaces.

I'll be honest here: I don't have much experience with workspaces. I don't know
the ins-and-outs of how they work with each package manager (`npm`, `yarn`, `pnpm`, `bun`).
But I figured I would start with the original and work towards some of the
newer ones. I mention this because `npm` _may_ not be the easiest to work with.
The other package managers _may_ have features or different designs that
can better solve the problem.

npm workspaces, by themselves, are not too difficult to work with. It's that Docker
that adds some of the mentioned complexity. There is a bunch of information out
there about the benefits of Docker not only for development but also deployment. For now,
let's just focus on development.

## DRAFT

Phase 1 - Docker with npm workspaces
Phase 2 - Docker with pnpm workspaces
Phase 3 - Introduce turborepo

## References

- https://dev.to/moofoo/creating-a-development-dockerfile-and-docker-composeyml-for-yarn-122-monorepos-using-turborepo-896
