FROM n8nio/n8n:latest

WORKDIR /home/node

# Copy automation agent workflows and configuration
COPY workflows /home/node/workflows
COPY setup-agent.sh /home/node/setup-agent.sh
COPY .env.example /home/node/.env.example

# Make setup script executable
RUN chmod +x /home/node/setup-agent.sh

# Run setup script to create directory structure
RUN /home/node/setup-agent.sh

EXPOSE 5678

CMD ["n8n", "start"]
