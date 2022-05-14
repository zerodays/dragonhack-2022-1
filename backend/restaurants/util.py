def to_dict(obj):
    return obj.to_dict()


def to_list(objects):
    return list(map(to_dict, objects))
