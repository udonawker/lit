### [WebDAV with cURL](https://code.blogs.iiidefix.net/posts/webdav-with-curl/)

---

## Actions
### Reading Files/Folders

```
curl 'http://example.com/webdav'
```

### Creating new Folder

```
curl -X MKCOL 'http://example.com/webdav/new_folder'
```

### Uploading File

```
curl -T '/path/to/local/file.txt' 'http://example.com/webdav/test/new_name.txt'
```

### Renaming File

```
curl -X MOVE --header 'Destination:http://example.org/webdav/new.txt' 'http://example.com/webdav/old.txt'
```


### Deleting Files/Folders
File:<br>

```
curl -X DELETE 'http://example.com/webdav/test.txt'
```

Folder:<br>

```
curl -X DELETE 'http://example.com/webdav/test'
```

### List Files in a Folder

```
curl -i -X PROPFIND http://example.com/webdav/ --upload-file - -H "Depth: 1" <<end
<?xml version="1.0"?>
<a:propfind xmlns:a="DAV:">
<a:prop><a:resourcetype/></a:prop>
</a:propfind>
end
```

## Options
### Authentication

Basic:<br?

```
curl --basic --user 'user:pass' 'http://example.com/webdav'
```

Digest:<br>

```
curl --digest --user 'user:pass' 'http://example.com/webdav'
```

let cURL choose:<br>

```
curl --anyauth --user 'user:pass' 'http://example.com/webdav'
```

### Get response code

```
curl -X DELETE 'http://example.com/webdav/test' -sw '%{http_code}'
```
