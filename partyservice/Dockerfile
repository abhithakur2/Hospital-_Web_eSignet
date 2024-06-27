FROM node:16.13.2-alpine as build

ENV work_dir=/app

WORKDIR ${work_dir}

#RUN addgroup -g ${container_user_gid} ${container_user} && \
#    adduser ${container_user} -G ${container_user} -u ${container_user_uid} --disabled-password
#Copy the app
COPY . ./
ENV PORT=8888

# change permissions of file inside working dir
#RUN chown -R ${container_user}:${container_user} ${work_dir}

# select container user for all tasks
#USER ${container_user}

EXPOSE ${PORT}

RUN npm install
CMD ["node", "./app.js"]
