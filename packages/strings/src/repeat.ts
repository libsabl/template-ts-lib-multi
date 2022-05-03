// Copyright 2022 REPO_AUTHORS. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.

export function repeat(msg: string, count = 1) {
  return new Array(count + 1).join(msg);
}
