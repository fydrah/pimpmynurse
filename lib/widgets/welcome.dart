import 'package:flutter/material.dart';
import 'package:pimpmynurse/utils/kv_store.dart';

class Welcome {
  static void welcome(context) {
    String welcomed = 'welcomed';
    String version = 'v0.0.1';
    if (KVStore.localStorage.getBool('${welcomed}_$version') == null ||
        !KVStore.localStorage.getBool('${welcomed}_$version')!) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Welcome'),
                content: const Text('''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. In ornare quam viverra orci sagittis eu. Vivamus at augue eget arcu dictum varius. Proin sed libero enim sed faucibus. Vulputate enim nulla aliquet porttitor. Feugiat nisl pretium fusce id velit ut tortor pretium viverra. Nulla at volutpat diam ut venenatis. Lectus urna duis convallis convallis tellus id interdum velit. Nunc pulvinar sapien et ligula ullamcorper. Venenatis cras sed felis eget velit aliquet sagittis id. Amet nisl purus in mollis. Massa enim nec dui nunc mattis. Consectetur a erat nam at lectus urna duis convallis. Enim nunc faucibus a pellentesque sit. Nulla facilisi etiam dignissim diam quis enim. Eu non diam phasellus vestibulum lorem sed risus. Id semper risus in hendrerit gravida rutrum. Quam nulla porttitor massa id neque aliquam. Eget est lorem ipsum dolor sit amet. Orci nulla pellentesque dignissim enim sit amet venenatis urna cursus.

Aenean pharetra magna ac placerat. Metus vulputate eu scelerisque felis imperdiet proin. Elementum integer enim neque volutpat ac. Gravida rutrum quisque non tellus orci ac auctor augue. In hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit. Massa sapien faucibus et molestie. Amet consectetur adipiscing elit duis. Proin libero nunc consequat interdum varius sit amet. Suspendisse ultrices gravida dictum fusce ut placerat orci. Enim nunc faucibus a pellentesque sit amet. Ac felis donec et odio pellentesque diam volutpat. Elementum integer enim neque volutpat.
              '''),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close')),
                ],
              )).then((_) {
        KVStore.localStorage.setBool('${welcomed}_$version', true);
      });
    }
  }
}
