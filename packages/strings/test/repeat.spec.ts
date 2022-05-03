// Copyright 2022 REPO_AUTHORS. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.

import { repeat } from '$';

describe('repeat', () => {
  it('repeats input', () => {
    const result = repeat('a', 4);
    expect(result).toBe('aaaa');
  });

  it('defaults to count = 1', () => {
    const result = repeat('a');
    expect(result).toBe('a');
  });
});
