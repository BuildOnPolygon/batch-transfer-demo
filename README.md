# ERC20 Multi-Transfer Extension

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CI Status](../../actions/workflows/test.yaml/badge.svg)](../../actions)

## Gas Simulation Tests

In order to simulate the difference in native multi-transfer versus sending the transactions individually can be seen in the gas snapshot.

- The gas snapshot for the ERC20 Multi-Transfer Extension can be found [here](.gas-snapshot).
- The gas report for more detailed tests can be found [here](gas-report.json).

To generate the gas report, run the following command:

```bash
./script/util/gen_gas_report.sh
```

To view the `Foundry` gas report, run the following command:

```bash
forge test --gas-report
```

---

## Setup

Follow these steps to set up your local environment:

- [Install foundry](https://book.getfoundry.sh/getting-started/installation)
- Install dependencies: `forge install`
- Build contracts: `forge build`
- Test contracts: `forge test`

If you intend to develop on this repo, follow the steps outlined in [CONTRIBUTING.md](CONTRIBUTING.md#install).

## Docs

The documentation and architecture diagrams for the contracts within this repo can be found [here](docs/).
Detailed documentation generated from the NatSpec documentation of the contracts can be found [here](docs/autogen/src/src/).
When exploring the contracts within this repository, it is recommended to start with the interfaces first and then move on to the implementation as outlined [here](CONTRIBUTING.md#natspec--comments)

## Contributing

If you want to contribute to this project, please check [CONTRIBUTING.md](CONTRIBUTING.md) first.

## License

​
Licensed under either of
​

- Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or <http://www.apache.org/licenses/LICENSE-2.0>)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or <http://opensource.org/licenses/MIT>)
  ​

at your option.

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without any additional terms or conditions.

---

© 2023 PT Services DMCC
