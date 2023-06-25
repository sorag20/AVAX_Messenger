import ChangeOwnerValueForm from '../components/form/ChangeOwnerValueForm';
import Layout from '../components/layout/Layout';
import RequireWallet from '../components/layout/RequireWallet';
import { useMessengerContract } from '../hooks/useMessengerContract';
import { useWallet } from '../hooks/useWallet';

export default function OwnerPage() {
  const { currentAccount, connectWallet } = useWallet();
  const { processing, owner, numOfPendingLimits, changeNumOfPendingLimits } =
    useMessengerContract({
      currentAccount: currentAccount,
    });

  return (
    <Layout>
      <RequireWallet
        currentAccount={currentAccount}
        connectWallet={connectWallet}
      >
        {owner === currentAccount ? (
          <ChangeOwnerValueForm
            processing={processing}
            currentValue={numOfPendingLimits}
            changeValue={changeNumOfPendingLimits}
          />
        ) : (
          <div>Unauthorized</div>
        )}
      </RequireWallet>
    </Layout>
  );
}
