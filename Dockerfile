FROM ubuntu:latest
MAINTAINER daephx <daephxdev@gmail.com>

# OS updates and install
RUN apt-get -qq update
RUN apt-get install git sudo zsh -qq -y

# Install extra dependencies
RUN apt-get install -y \
  python3-dev

# Create test user and add to sudoers
RUN useradd -m -s /bin/zsh dotuser
RUN usermod -aG sudo dotuser
RUN echo "dotuser   ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

# Add dotfiles and chown
ADD . /home/dotuser/projects/dotfiles
RUN chown -R dotuser:dotuser /home/dotuser

# Switch testuser
USER dotuser
ENV HOME /home/dotuser

COPY . /home/dotuser/.dotfiles

# Change working directory
WORKDIR /home/dotuser/.dotfiles

## Run setup
# RUN ./install.ps1 docker

CMD ["/bin/bash"]
