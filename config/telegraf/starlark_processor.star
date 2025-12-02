[[processors.starlark]]
  namepass = ["mqtt_consumer"]
  source = '''
def apply(metric):
    import json,time
    
    raw = metric.get_string("payload")
    if not raw:
        return None

    try:
        p = json.loads(raw)
    except:
        return None

    if "object" not in p:
        return None

    fields = {}
    tags = {}

    def esc(v):
        return str(v).strip()

    # timestamp desde p.time
    try:
        ts = int(time.mktime(time.strptime(p.get("time"), "%Y-%m-%dT%H:%M:%SZ")))
        metric.time = ts * 1000000000
    except:
        pass

    # tags base
    app = p.get("deviceInfo", {}).get("applicationName", "unknown")
    tags["application"] = esc(app)
    tags["deviceName"] = esc(p.get("deviceInfo", {}).get("deviceName", ""))
    tags["devEUI"] = esc(p.get("deviceInfo", {}).get("devEui", p.get("devEUI","")))

    # measurement = applicationName
    metric.name = esc(app)

    # procesar valores en p.object
    for k,v in p["object"].items():
        if v in ["True","true"]: v = 1
        elif v in ["False","false"]: v = 0
        elif v == "LOW": v = 0
        elif v == "HIGH": v = 1
        elif isinstance(v,str):
            try:
                num=float(v)
                v=num
            except:
                fields[k]=v
                continue

        if isinstance(v,(int,float)):
            fields[k]=v

    # aplicar tags y fields
    for k,v in tags.items():
        metric.tags[k]=v

    for k,v in fields.items():
        metric.fields[k]=v

    return metric
'''
