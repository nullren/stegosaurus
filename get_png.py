import requests

d = requests.get("http://www.reddit.com/r/pics/.json").json()

print("got list of images")

posts = d['data']['children']
links = [post['data']['url'] for post in posts if post['data']['url'].find("png")>=0]

for link in links:
  print("downloading link <{}>...".format(link))
  r = requests.get(link)
  print("downloaded!")
  fd = open("test_images/{}.png".format(hash(link)%1000003), "wb")
  fd.write(r.content)
  fd.close()
