+++
date = "2020-06-24T11:10:38-04:00"
title = "Name coupling"
draft = true
+++

<!--
MAIN POINTS:

  - In the search of abstraction, we sometimes couple names (e.g., URLs, file paths)
  - When a change in URL/directory structure happens (or when testing/running manually) the coupling limits the user

-->

I often see name coupling when URLs and directory names share a sub-path.
Suppose we wanted to download the content of there S3 URLs to these directories on disk:

```
s3://my-bucket/2020-06-23/ ⇒ /var/lib/my-service/2020-06-23/
s3://my-bucket/2020-06-24/ ⇒ /var/lib/my-service/2020-06-24/
s3://my-bucket/2020-06-25/ ⇒ /var/lib/my-service/2020-06-25/
```

```
s3://my-bucket/2020-06-26/CA/ ⇒ /var/lib/my-service/2020-06-26/CA/
s3://my-bucket/2020-06-26/US/ ⇒ /var/lib/my-service/2020-06-26/US/
s3://my-bucket/2020-06-27/CA/ ⇒ /var/lib/my-service/2020-06-27/CA/
s3://my-bucket/2020-06-27/US/ ⇒ /var/lib/my-service/2020-06-27/US/
```


<!--
## The problem

In the past weeks, I've been bitten by an anti-pattern that I call *name coupling*.
Name coupling occurs where names (e.g., two file paths) share a sub-string and a “helpful” programmer abstracts the common sub-string (e.g., extracting a commong sub-directory name).
When names are coupled, the code is less resilient to changes in the name structure or new structures.

## An example

Suppose we want to download directories from S3 and the name of the S3 directories and the names we want to give them locally share a date component.

```
s3://my-bucket/foo/2020-06-24/ ⇒ /var/lib/my-service/foo/2020-06-24/
s3://my-bucket/bar/2020-06-24/ ⇒ /var/lib/my-service/bar/2020-06-24/
```

A programmer might see the shared date sub-directory names and decide to abstract them out, giving a function like this:

```
def download_dir(s3_prefix, path_prefix, date):
    s3_url = s3_prefix + '/' + date
    path = os.path.join(path_prefix, date)
    s3.download(s3_url, path)

download_dir("s3://my-bucket/foo", "/var/lib/my-service/foo", "2020-06-24")
download_dir("s3://my-bucket/bar", "/var/lib/my-service/bar", "2020-06-24")
```

However, suppose that we have a new S3 directory to download, one that has a different structure than the existing ones:

```
s3://my-bucket/quux/2020/06/24/ ⇒ /var/lib/my-service/quux/2020-06-24/
```

Now we're screwed, the `download_dir` function cannot be used, because the name of the URL and the name of the local path don't line up.

## A solution

One way to avoid the problem of name coupling is to not try and break names into unique parts and common parts and just give out the names in full.
In that case, in our example above we wouldn't need the `download_dir` function and we wouldn't be jammed if a directory structure changed:

```
s3.download("s3://my-bucket/foo/2020-06-24", "/var/lib/my-service/foo/2020-06-24")
s3.download("s3://my-bucket/bar/2020-06-24", "/var/lib/my-service/bar/2020-06-24")
s3.download("s3://my-bucket/quux/2020/06/24", "/var/lib/my-service/quux/2020-06-24")
```
-->
