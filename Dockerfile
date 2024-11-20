# 第一阶段：构建阶段，使用 Node.js 镜像
FROM node:14-alpine AS build

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

Run npm config set registry https://registry.npmmirror.com
# 安装依赖
RUN npm install

# 复制项目文件并执行构建
COPY . .
RUN npm run build

# 第二阶段：部署阶段，使用 Nginx 镜像
FROM nginx:alpine

# 复制构建好的静态文件到 Nginx 的静态资源目录
COPY --from=build /app/dist /usr/share/nginx/html

# 暴露 Nginx 默认端口
EXPOSE 80

# 启动 Nginx 服务
CMD ["nginx", "-g", "daemon off;"]