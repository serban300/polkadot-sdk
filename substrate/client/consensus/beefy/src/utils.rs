// This file is part of Substrate.

// Copyright (C) Parity Technologies (UK) Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later WITH Classpath-exception-2.0

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

use sc_client_api::{Backend, BlockchainEvents, Finalizer};
use sp_api::ProvideRuntimeApi;
use sp_blockchain::HeaderBackend;
use sp_runtime::{
	generic::BlockId,
	traits::{Block, NumberFor},
};

pub trait BeefyBackend<B>: Backend<B>
where
	B: Block,
{
	/// Get block header. Returns `String` error if block is not found.
	fn expect_header_from_number(&self, number: NumberFor<B>) -> Result<B::Header, String> {
		let hash = self.blockchain().expect_block_hash_from_id(&BlockId::Number(number)).map_err(
			|err| format!("Couldn't get hash for block #{:?} (error: {:?}).", number, err),
		)?;

		self.blockchain().expect_header(hash).map_err(|err| {
			format!("Couldn't get header for block #{:?} ({:?}) (error: {:?}).", number, hash, err)
		})
	}
}

impl<B, T> BeefyBackend<B> for T
where
	B: Block,
	T: Backend<B>,
{
}

/// A convenience BEEFY client trait that defines all the type bounds a BEEFY client
/// has to satisfy. Ideally that should actually be a trait alias. Unfortunately as
/// of today, Rust does not allow a type alias to be used as a trait bound. Tracking
/// issue is <https://github.com/rust-lang/rust/issues/41517>.
pub trait Client<B, BE>:
	BlockchainEvents<B> + HeaderBackend<B> + Finalizer<B, BE> + Send + Sync
where
	B: Block,
	BE: Backend<B>,
{
	// empty
}

impl<B, BE, T> Client<B, BE> for T
where
	B: Block,
	BE: Backend<B>,
	T: BlockchainEvents<B>
		+ HeaderBackend<B>
		+ Finalizer<B, BE>
		+ ProvideRuntimeApi<B>
		+ Send
		+ Sync,
{
	// empty
}
