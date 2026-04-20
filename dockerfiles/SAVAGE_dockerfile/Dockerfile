FROM mambaorg/micromamba:git-5f62561-cuda11.8.0-ubuntu22.04

LABEL version="1.0"

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /tmp/environment.yml

RUN micromamba install -y -n base -f /tmp/environment.yml && micromamba clean --all --yes

ARG MAMBA_DOCKERFILE_ACTIVATE=1
WORKDIR /work

RUN chown -R $MAMBA_USER:$MAMBA_USER /work

CMD ["bash"]