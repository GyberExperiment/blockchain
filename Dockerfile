# Используем официальный образ Rust для сборки Substrate node
FROM rust:1.69 as builder

WORKDIR /substrate-node 

# Устанавливаем необходимые зависимости
RUN apt-get update && \
    apt-get install -y git clang curl libssl-dev llvm libudev-dev protobuf-compiler && \
    rm -rf /var/lib/apt/lists/*

# Копируем из репозитория шаблон Substrate Node
COPY . .

# Собираем Substrate Node Template
RUN sh -c "cd scripts && chmod +x init.sh && ./init.sh"
RUN rustup target add wasm32-unknown-unknown

RUN cargo build --release --package node-template --locked

# # Создаем конечный образ с минимальными зависимостями
# FROM debian:buster-slim
# WORKDIR /substrate-node

# # Устанавливаем зависимости для исполняемого файла
# RUN apt-get update && \
#     apt-get install -y libssl1.1 g++ libgtk-3-dev libfreetype6-dev libx11-dev libxinerama-dev libxrandr-dev libxcursor-dev mesa-common-dev libasound2-dev freeglut3-dev libxcomposite-dev libcurl4-openssl-dev && \
#     rm -rf /var/lib/apt/lists/*

# # Копируем собранный бинарный файл из билдера
# COPY --from=builder /substrate-node/target/release/node-template /usr/local/bin

# # Экспонируем порты P2P и RPC
# EXPOSE 30333 9933 9944

# # Запускаем Substrate Node Template с настройками по умолчанию
# CMD ["node-template", "--dev"]
