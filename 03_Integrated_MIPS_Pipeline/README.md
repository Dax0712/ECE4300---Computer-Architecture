# Integrated Simplified MIPS Pipeline

This section is for the corrected stage implementations used together in the final processor.

## Pipeline

```text
IF -> ID -> EX -> MEM -> WB
```

The top-level pipeline connects the stage boundaries and exposes selected internal signals to make Vivado waveform verification easier.

The integrated version is kept separate from the earlier stage assignments so the final working design is easy to find.
