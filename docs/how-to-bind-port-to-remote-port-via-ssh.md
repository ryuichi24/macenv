# How to Bind Port to Remote Port via SSH

```bash
ssh -N -L <local port>:<remote host>:<remote port> <username>@<ssh remote hostname>
```

- `ssh` — starts an SSH connection.
- `-N` — does not open a remote shell or run a remote command. The connection exists only for forwarding traffic.
- `-L` — creates a local port forward.

> [!NOTE]
> You can use `-L` option multiple times to create multiple local port forwards.
>
> ```bash
> ssh -N \
>   -L 8080:127.0.0.1:3000 \
>   -L 8081:127.0.0.1:4000 \
>   -L 8082:127.0.0.1:5000 \
>   username@<ssh remote hostname>
> ```
