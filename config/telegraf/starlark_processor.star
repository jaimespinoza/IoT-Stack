def apply(metric):
    p = metric.fields.get("object")
    if p == None:
        return []

    di = metric.fields.get("deviceInfo")
    if di != None:
        app = di.get("applicationName", "unknown")
    else:
        app = "unknown"

    metric.name = app

    fields_out = {}

    for k in p:
        v = p[k]

        if v == "True" or v == "true" or v == "HIGH":
            v = 1
        elif v == "False" or v == "false" or v == "LOW":
            v = 0

        if type(v) == "int" or type(v) == "float":
            fields_out[k] = v

    metric.fields = fields_out
    return [metric]
