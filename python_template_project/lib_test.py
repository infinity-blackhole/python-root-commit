# SPDX-FileCopyrightText: 2022-present William Phetsinorath
#
# SPDX-License-Identifier: MIT

from . import sum


def test_sum():
    assert sum(1, 2) == 3
