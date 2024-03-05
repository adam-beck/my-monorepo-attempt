# My Monorepo Attempt

The whole purpose of this repo is to figure out how to create an ideal
development environment using Docker. While monorepos are not always the
best tool for the job, they do provide some benefits. Unfortunatley, those
benefits come with some infrastructure complexity -- tradeoffs. Adding Docker
into the mix has proven to be even more challenging.

So how do we solve a complex problem? We break it down. And that's exactly
what we are going to be doing here. The plan is to start with a basic setup
using only npm workspaces.

<aside>
I'll be honest here: I don't have much experience with workspaces. I don't know
the ins-and-outs of how they work with each package manager (`npm`, `yarn`, `pnpm`, `bun`).
But I figured I would start with the original and work towards some of the
newer ones. I mention this because `npm` _may_ not be the easiest to work with.
The other package managers _may_ have features or different designs that
can better solve the problem.
</aside>

npm workspaces, by themselves, are not too difficult to work with. It's that Docker
that adds some of the mentioned complexity. There is a bunch of information out
there about the benefits of Docker not only for development but also deployment. For now,
let's just focus on development.

## Phase 1 - Docker with npm Workspaces

The goal of this phase is to just get a pleasant local development environment
using `npm`, `npm` workspaces, and Docker. Other tools may be used but ultimatley we should
avoid things like `turborepo` (even it would make things easier). A basic understanding
without too much abstraction, that is what we are striving for.

So what does a pleasant local development environment look like? For this basic example
a simple node server (in a container) and a shared library. That's it. Two "apps". However,
when the shared library is updated, the containerized node server should be updated. We will try to
follow a few Docker best practices but the notion of production is not a concern yet. Things
like ensuring the `node_modules` are not synced between the host and the docker containers -- they
should be installed in the container and isolated. Typescript is usually a wise choice except
it requires a build step. That will be addressed later.

Let's begin.

<aside>Open tag (TODO: add tag for this step) and I'll cover some sections I think are important.</aside>

First, let's look at the root Dockerfile. It's pretty basic but it gets our entire monorepo
into a single container. _Everything_ is included (except for any `node_modules` directory on the
host because of the `.dockerignore`). You'll have to decide what base image works best
for your project but here we're just using a version of [node 20.11.1](https://hub.docker.com/layers/library/node/20.11.1-bullseye-slim/images/sha256-bc0ff0ad6f4a4817cf28fcafafe8ed3c0c56197ef67ecd21dce4a6400047151a?context=explore).
The rest of the Dockerfile should be pretty self explanatory. The `CMD` at the end can be ignored because
it'll be overridden in our Compose file. Again, we're currently only focusing on development environment.

Our project only has one server but you'll need to know which ports to expose. For example, in the
next phase we'll add another node server that will have to live on a different port. We'll have to
add another `EXPOSE` line to this Dockerfile.

Next, let's look at the Dockerfile for our node server. It looks very similar to the root one.
However, it's more localized for this particular app.

<aside>One thing that really threw me off when researching this topic was that I wanted the
Dockerfile for this server to be _entirely_ self-contained -- I didn't want to use any files
outside of the `apps/server` directory. For a monorepo, that doesn't really make sense. I had
to change my mindset that, while these are somewhat separate apps, they still exist together as a group.
</aside>

If you pay close attention, you'll notice that these files are coming from the root of the project
as well as from our server's directory `apps/server`. This hints that we cannot use `apps/server` for our
build context. The image must be built with the root as the context. This is a monorepo. Docker
is all about compartmentalizing our applications but we still have to adhere to the spirt
of a monorepo in that we now have a project that is apart of something bigger.

<aside>
With all that said, this file actually isn't all that important at this step. It's not being
used anywhere. I only mentioned it here because this really threw me off for quite some time.
</aside>

Outside of that, we still install the `node_modules` (within the image; not on the host). And again,
we can ignore the `CMD` for the same reason above: the Compose file will handle this.

Finally, we get to the `compose.yml` file. It's yet another pretty basic file. The `build` context
is the root of the repository (so we have access to everything) and it utilizes the first Dockerfile
we discussed. 

Speaking of `nodemon` you may have seen a real ugly `command` in our compose file. It's unfortunate, but
we have to include all of our dependent workspace projects in the command or watch the entire project. Nodemon, to my knowledge, does not
follow symlinks which is what we have in the `node_modules` for our workspace modules. If we
watch the entire project, any time anything changes (related or not) it will restart our server. If that's okay with you, you can
go that route. This second approach is commented out in the Compose file.

<aside>
I originally tried using `npm run dev --workspace=server` for the `command`. In the `package.json` of the server I created a `dev` script that looked like

```json
"dev": "nodemon index.js"
```

Unfortunatley, this would only watch the `apps/server` directory. Not the root's `node_modules` or any of the other workspace modules that are being relied on. You can, instead,
do this

```json
"dev": "nodemon -w ../.. index.js"
```

Which get's us back to watching everything in our project. Or even

```json
"dev": "nodemon -w ../../packages/logger index.js"
```

And include all the packages that are required by server. I'm hoping to address this later and instead chose the more verbose `command` in `compose.yml` for now and
I've commented this other approach out as well.
</aside>

If you remember the `EXPOSE 3000` we included in the second Dockerfile, the `ports` section should make sense.
That's the port we'll also use on the host to access our server.

The `not-used` volume is a way to avoid having our host's `node_modules` within our container or our
container's `node_modules` being synced with our host. This is a practice that's used because you
certain modules rely on the architecture/OS of the system itself. If you were, let's say on Windows, you
wouldn't want those certain modules to be built for Windows inside your container which uses Linux. There is
a chance that our sub-projects could contain their own `node_modules` and that will not be resolved by
this trick.

That's it. If you were to run `docker compose up` from the root you should see in the logs our `nodemon` output
as well as the `logger.log` functions that utilize our `packages/logger` module. If you make a change to either
the node server or the `logger` module, the server should automatically restart (we aren't ignoring `node_modules` with `nodemon` as can be seen in `apps/server/nodemon.json`).

That's a good first step!

## Phase 2

Let's add another server to our monorepo. With the setup we have in Phase 1, this shouldn't be too difficult.

## DRAFT

Phase 1 - Docker with npm workspaces
Phase 2 - Docker with pnpm workspaces
Phase 3 - Introduce turborepo

## References

- https://dev.to/moofoo/creating-a-development-dockerfile-and-docker-composeyml-for-yarn-122-monorepos-using-turborepo-896
