FROM ubuntu:latest
MAINTAINER daephx <36192863+daephx@users.noreply.github.com>

# OS updates and install
RUN apt-get -qq update
RUN apt-get install git sudo zsh -qq -y

# Install extra dependencies
RUN apt-get install -y \
  python3-dev

# Create test user and add to sudoers
RUN useradd -m -s /bin/zsh tester
RUN usermod -aG sudo tester
RUN echo "tester   ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

# Add dotfiles and chown
ADD . /home/tester/projects/dotfiles
RUN chown -R tester:tester /home/tester

# Switch testuser
USER tester
ENV HOME /home/tester

COPY . /home/tester/.dotfiles

# Change working directory
WORKDIR /home/tester/.dotfiles

## Run setup
RUN ./setup

CMD ["/bin/bash"]
