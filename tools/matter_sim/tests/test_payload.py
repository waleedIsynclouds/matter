from matter_sim.payload import decode_code, generate_codes


def test_default_code_generation_uses_matter_test_vector():
    codes = generate_codes()

    assert codes.qr_code == "MT:-24J0AFN00KA0648G00"
    assert codes.manual_code == "34970112332"
    assert codes.discriminator == 3840
    assert codes.passcode == 20202021


def test_default_qr_decodes_to_matter_test_vector():
    codes = decode_code("MT:-24J0AFN00KA0648G00")

    assert codes.manual_code == "34970112332"
    assert codes.discriminator == 3840
    assert codes.passcode == 20202021


def test_default_manual_decodes_to_matter_test_vector():
    codes = decode_code("34970112332")

    assert codes.qr_code == "MT:-24J0AFN00KA0648G00"
    assert codes.discriminator == 3840
    assert codes.passcode == 20202021
