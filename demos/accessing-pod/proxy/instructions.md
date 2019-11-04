kubectl proxy
open http://127.0.0.1:8001
open http://127.0.0.1:8001/api/v1/pods
open http://127.0.0.1:8001/api/v1/namespaces/default/pods/helloapp (get selfLink)
open http://127.0.0.1:8001/api/v1/namespaces/default/pods/http:helloapp:8080/proxy/

http[s]:pod|service_name:[port_name]/proxy

