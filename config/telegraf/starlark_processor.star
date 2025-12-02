[[processors.starlark]]
  namepass = ["mqtt_consumer"]
  source = '''
def apply(metric):
    raw = metric.fields.get("payload")
    if not raw:
        return None

    # intentar parsear JSON manualmente (solo objetos simples)
    try:
        raw = raw.strip()
        # quitar { } inicial y final
        if raw.startswith("{") and raw.endswith("}"):
            raw = raw[1:-1]

        p = {}
        for pair in raw.split(","):
            if ":" in pair:
                k,v = pair.split(":",1)
                k = k.strip().strip('"')
                v = v.strip().strip('"')
                p[k] = v
    except:
        return None

    if "object" not in p:
        return None

    fields = {}
    tags = {}

    def esc(v):
        return str(v).strip()

    # tags base
    app = p.get("deviceInfo_applicationName", "unknown")
    tags["application"] = esc(app)
    tags["deviceName"] = esc(p.get("deviceInfo_deviceName", ""))
    tags["devEUI"] = esc(p.get("deviceInfo_devEui", p.get("devEUI","")))

    # measurement = applicationName
    metric.name = esc(app)

    # procesar valores en object (aun como string)
    obj_prefix = "object_"
    for k,v in p.items():
        if k.startswith(obj_prefix):
            key = k[len(obj_prefix):]
            val = v
            if val in ["True","true","HIGH"]:
                val = 1
            elif val in ["False","false","LOW"]:
                val = 0
            else:
                try:
                    val = float(val)
                except:
                    pass
            fields[key] = val

    # aplicar
