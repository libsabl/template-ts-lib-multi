// Copyright 2022 REPO_AUTHORS. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.

// An import from elsewhere in src
import { repeat } from '@example/strings';

/**
 * A ridiculous way to multiply a number by a certain power of ten
 * @param {number} n The number to multiply. Will be truncated to an integer
 * @param {number} ordersOfMagnitude An integer number of how many zeros to add
 */
export function powten(n: number, ordersOfMagnitude: number) {
  n = Math.trunc(+n || 0);
  const om = Math.abs(Math.trunc(+ordersOfMagnitude || 0));
  const nstr = n.toFixed(0) + repeat('0', om);
  return +nstr;
}
