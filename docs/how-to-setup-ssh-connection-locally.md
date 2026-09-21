# How to Setup SSH to Connect Mac PCs locally

## Generate SSH Key

Run the following command to generate a new SSH key.

```bash
ssh-keygen -t ed25519 -f ~/.ssh/<key file name> -C "human readable comment or label for the key"
```

This prompts you for a passphrase. You can leave it blank if you don't want to use a passphrase.

> [!NOTE]
> If you leave the passphrase blank, you can add it later by running `ssh-keygen -p -f ~/.ssh/<key file name>`.

## Add SSH Public Key to Dest Machine

After running the `ssh-keygen` command, you will 2 files in your `~/.ssh` directory:

```bash
ls ~/.ssh
```

```bash
<key file name> <key file name>.pub
```

## Setup SSH on Dest Machine

On the Mac you want to control, open:

`System Settings → General → Sharing → Remote Login`

And Enable `Remote Login`

## Find the IP Address of the Dest Machine

```bash
ifconfig bridge0
```

> [!NOTE]
> `bridge0` is the network interface name macOS commonly assigns to Thunderbolt Bridge.
> `ifconfig` means `interface configuration`, a Unix command to view and configure network interfaces.

## SSH into Desk Machine with Password and Put Public Key

From the macOS terminal, run the following command:

```bash
ssh <username>@<host name>
```

And you will be asked to type password of the desk machine.

Create `~/.ssh/authorized_keys` file on the desk machine if it doesn't exist.

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
```

Copy the contents of `<key file name>.pub` in the file of the host machine to the `~/.ssh/authorized_keys` file on the destination machine.

> [!NOTE]
> On your host machine, you can do the same thing with:
>
> ```bash
> cat ~/.ssh/<key file name>.pub | ssh <user name>@<host name>.local 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
> ```

Now you can ssh into the desk machine without password with:

```bash
ssh -i ~/.ssh/<key file name>.pub <username>@<host name>
```

To avoid specifying the key file name every time with `-i` option, you can add the following line to your `~/.ssh/config` file:

```txt
Host <label name>
    HostName <host name>
    User <username>
    IdentityFile ~/.ssh/<key file name>
    IdentitiesOnly yes
```

and then you can ssh into there with:

```bash
ssh <label name>
```
