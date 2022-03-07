# TimeIntervalFormatStyle

Simple ParseableFormatStyle conformace for TimeInterval, with and without milliseconds.

## Input

Can accept string timestamps formatted with hours, minutes, seconds, and, optionally, milliseconds. The parser will handle missing 0-padding

### Example inputs
- 0:10:45.333   -> Valid
- 0:2:45.333    -> Valid (0-padding missing OK)
- 20:10:45.2    -> Valid (0 padding on milliseconds missing)
- 20:10:45.200  -> Valid (more than 1 hour digit)
- 0:10:45       -> Valid (no milliseconds)
- 0:10:45.22323 -> Valid (milliseconds go beyond thousandths place)
- 0:10:45:220   -> Valid (millisecond delimiter swapped)
--------------------------
- 10:45.222     -> Invalid (must have hours, even if 0)
- 0:10:45.aaa   -> Invalid (non-digit characters)
- 0-10:45.000   -> Invalid (wrong delimiter)
- 1:10:62.222   -> Invalid (too many seconds)

## Output

Using `showsMilliseconds` the client can control if milliseconds are shown or not. All output will be 0-padded and contains exactly 3 places of milliseconds.

- With milliseconds:    2:03:44.232
- Without milliseconds: 2:03:44

## Usage in SwiftUI

I built this to be able to easily move to/from TimeIntervals in SwiftUI TextFields. A simple example below!

```Swift

struct TimeIntervalTextField: View {
    @Binding var duration: TimeInterval
    
    var body: some View {
        TextField("Duration:", value: $duration, format: .timeInterval(showMilliseconds: true), prompt: nil)
    }
}

```
