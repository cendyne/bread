#include <janet.h>

int classify_string(const uint8_t * data, int32_t length)
{
  if (length <= 0)
  {
    // If we're going to have a sane default..?
    return 0;
  }

  int binary = 0;
  int utf8 = 0;
  const uint8_t * end = data + length;
  while (data < end)
  {
    uint8_t first = *data++;
    if (first == 0)
    {
      janet_printf("Binary because 0\n");
      binary = 1;
      break;
    }
    else if (first == 9 || first == 10 || first == 13)
    {
      // standard whitespace is ascii..
      utf8 = 1;
      continue;
    }
    else if (first < ' ')
    {
      // But the other values there are just terminal control codes.
      janet_printf("Binary because terminal control codes\n");
      binary = 1;
      break;
    }
    else if (first >= ' ' && first < 0x80)
    {
      // and UTF-8 contains ascii.
      utf8 = 1;
      continue;
    }
    if (data + 1 > end)
    {
      binary = 1;
      break;
    }

    uint8_t second = *data++;
    if ((second >> 6) != 2)
    {
      janet_printf("Binary because invalid utf8 %d %d\n", first, second);
      binary = 1;
      break;
    }
    if (first < 0xE0)
    {
      utf8 = 1;
      continue;
    }
    if (data + 1 > end)
    {
      binary = 1;
      break;
    }

    uint8_t third = *data++;
    if ((third >> 6) != 2)
    {
      janet_printf("Binary because invalid utf8 %d %d %d\n", first, second, third);
      binary = 1;
      break;
    }
    if (first < 0xF0)
    {
      utf8 = 1;
      continue;
    }
    if (data + 1 > end)
    {
      binary = 1;
      break;
    }

    uint8_t fourth = *data++;
    if ((fourth >> 6) != 2)
    {
      janet_printf("Binary because invalid utf8 %d %d %d %d\n", first, second, third, fourth);
      binary = 1;
      break;
    }
    if (first < 0xF8)
    {
      utf8 = 1;
      continue;
    }

    janet_printf("Binary because not utf8\n");
    binary = 1;

    break;
  }

  if (binary)
  {
    return 1;
  }
  if (utf8)
  {
    return 0;
  }

  // This isn't logical.
  return 1;
}

static Janet is_binary(int32_t argc, Janet * argv) {
    janet_arity(argc, 1, 1);
    Janet input = argv[0];
    if (janet_checktype(input, JANET_NIL))
    {
        return janet_wrap_boolean(0);
    }
    JanetByteView view;
    if (!janet_bytes_view(input, &view.bytes, &view.len)) {
        janet_printf("Binary because could not make byte view\n");
        return janet_wrap_boolean(1);
    }
    return janet_wrap_boolean(classify_string(view.bytes, view.len));
}

static const JanetReg cfuns[] = {
    {"is-binary", is_binary, NULL},
    {NULL, NULL, NULL}
};

JANET_MODULE_ENTRY(JanetTable *env) {
    janet_cfuns(env, "_bread", cfuns);
}